"""只读访问雪莲华发行包；MonoBehaviour 字段布局取自同包程序集。"""
from pathlib import Path
import struct

import UnityPy
from UnityPy.helpers import TypeTreeHelper
from UnityPy.helpers.Tpk import get_typetree_node
from UnityPy.helpers.TypeTreeGenerator import TypeTreeGenerator


class Source:
    def __init__(self, data):
        self.data=Path(data)
        self.env=UnityPy.load(str(self.data/'resources.assets'))
        version=next(iter(self.env.files.values())).unity_version.split('c')[0]
        self.generator=TypeTreeGenerator(version)
        self.generator.load_local_dll_folder(str(self.data/'Managed'))
        # Boost 会缓存生成节点的对齐信息；修正发行包的 Enabled 对齐后用 Python 解析。
        self.env.typetree_generator=self.generator

    def load(self, name):
        return self.env.load_file(str(self.data/name))

    def base(self, obj):
        return obj.read_typetree(get_typetree_node(114,obj.version),wrap=True,check_read=False)

    def script(self, obj):
        data=self.base(obj)
        if not data.m_Script.m_PathID:return None,None
        script=data.m_Script.read()
        return script.m_ClassName,data

    def fields(self, obj):
        data=self.base(obj);script=data.m_Script.read()
        node=self.generator.get_nodes_up(script.m_AssemblyName,script.m_ClassName)
        for child in node.m_Children:
            if child.m_Name=='m_Enabled':child.m_MetaFlag|=16384
        boost=TypeTreeHelper.read_typetree_boost
        TypeTreeHelper.read_typetree_boost=None
        try:return obj.read_typetree(node)
        finally:TypeTreeHelper.read_typetree_boost=boost

    def scene_names(self):
        env=UnityPy.load(str(self.data/'globalgamemanagers'))
        raw=next(o.get_raw_data() for o in env.objects if o.type.name=='BuildSettings')
        count=struct.unpack_from('<I',raw)[0];cursor=4;result={}
        for index in range(count):
            size=struct.unpack_from('<I',raw,cursor)[0];cursor+=4
            result[Path(raw[cursor:cursor+size].decode()).stem]='level'+str(index)
            cursor=(cursor+size+3)&~3
        return result
