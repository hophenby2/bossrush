-- Damage1.cs 的碰撞求值适配：只合并同一比较中重复的纯坐标读取，不改判定、顺序或效果。
-- 原始语法树产物保留在 source.lua，SHA256 14a3937772e743dd9db07c2b1b494e477b2ab756c5fba8e1fea0e69b37f3d601。
return function(CS,S,position,instantiate,destroy)
    local function overlaps(self,transform,target)
        local x,y=position(transform)
        local px,py=position(self.transform)
        local dx,dy=x-px,y-py
        local r=self.damage_r+target.sdbj
        return dx*dx+dy*dy<r*r
    end
    local function hit(self,target,isBoss)
        if target.wudi_time<=0 and not target.zidanwudi then
            target.life=target.life-self.damage
            S.fenshu_now=S.fenshu_now+10
            if self.reset_aim then S.zhuqiang_aim=target.transform end
            if self.add_jiejie then S.jiejiefanghu_val=math.min(299999,S.jiejiefanghu_val+50) end
            if isBoss and target.life<1200 and target.xuruo then S.se_enemy_hurt_count=S.se_enemy_hurt_count+1 end
        end
        if S.effect_cut<2 then instantiate(self.a,self.transform.position,self.transform.rotation) end
        destroy(self.gameObject)
    end
    return function(self)
        if self.damage<=0 then return end
        for i=S.enemy.Count-1,0,-1 do
            local t=S.enemy[i]
            self.bm=CS.invoke(t,'GetComponent','Enemymove')
            if overlaps(self,t,self.bm) and not self.bm.panding_off then hit(self,self.bm,false);break end
        end
        -- 原作击中普通敌机后仍继续检查 Boss，不能因 Destroy 已标记而提前返回。
        for i=S.boss.Count-1,0,-1 do
            local target=S.boss[i]
            self.bm2=CS.invoke(target,'GetComponent','Bossmove')
            if overlaps(self,target.transform,self.bm2) then hit(self,self.bm2,true);return end
        end
    end
end
