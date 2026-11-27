// 相邻材质批次共用一次顶点/索引上传；绘制顺序和每批材质仍由原命令决定。
// 16位索引只在当前数据块内寻址，达到65536个顶点前换下一块。
for (int first = 0; first < batchesTotal;) {
    int end = first;
    size_t vTotal = 0, iTotal = 0;
    while (end < batchesTotal) {
        size_t vertices = 0, indices = 0;
        for (auto* c : _triBatchesToDraw[end].cmds) {
            vertices += c->getVertexCount();
            indices += c->getIndexCount();
        }
        // 单个上游批次若已有更多顶点，仍单独上传，保留原先合法的局部索引。
        if (end != first && vTotal + vertices > 65536) break;
        vTotal += vertices; iTotal += indices; ++end;
    }
    const auto vbuffer = GlobalTriangleBufferPool.nextVertexData(vTotal);
    const auto ibuffer = GlobalTriangleBufferPool.nextIndexData(iTotal);
    size_t vCurrent = 0, iCurrent = 0;
    for (int i = first; i < end; ++i) {
        const auto& tb = _triBatchesToDraw[i];
        size_t batchIndices = 0;
        for (auto* c : tb.cmds) {
            const auto vcount = c->getVertexCount();
            const auto icount = c->getIndexCount();
            memcpy(vbuffer + vCurrent, c->getVertices(), sizeof(V3F_C4B_T2F) * vcount);
            if (!c->isSkipModelView()) {
                const auto& modelView = c->getModelView();
                for (size_t j = 0; j < vcount; ++j)
                    modelView.transformPoint(&vbuffer[vCurrent + j].vertices);
            }
            const auto indices = c->getIndices();
            for (size_t j = 0; j < icount; ++j)
                ibuffer[iCurrent + j] = static_cast<uint16_t>(vCurrent + indices[j]);
            vCurrent += vcount; iCurrent += icount; batchIndices += icount;
        }
        CC_ASSERT(batchIndices == tb.indicesToDraw);
    }
    auto b = GlobalTriangleBufferPool.nextBuffer(vTotal, iTotal);
    b.vb->updateData(vbuffer, sizeof(V3F_C4B_T2F) * vTotal);
    b.ib->updateData(ibuffer, sizeof(uint16_t) * iTotal);
    _filledVertex += vTotal; _filledIndex += iTotal;
    size_t indexOffset = 0;
    for (int i = first; i < end; ++i) {
        const auto& tb = _triBatchesToDraw[i];
        _commandBuffer->setVertexBuffer(b.vb);
        _commandBuffer->setIndexBuffer(b.ib);
        auto& pipelineDescriptor = tb.cmd->getPipelineDescriptor();
        _commandBuffer->updatePipelineState(_currentRT, pipelineDescriptor);
        _commandBuffer->setProgramState(pipelineDescriptor.programState);
        // GFX的offset单位为字节，内部再按索引步长换算firstIndex。
        _commandBuffer->drawElements(backend::PrimitiveType::TRIANGLE, backend::IndexFormat::U_SHORT,
                                    tb.indicesToDraw, indexOffset * sizeof(uint16_t));
        indexOffset += tb.indicesToDraw;
        ++_drawnBatches; _drawnVertices += tb.indicesToDraw;
    }
    first = end;
}
