
---默认消弹效果
BulletBreak=Class(object)

local BulletBreak_Image={} for i=1,16 do BulletBreak_Image[i]="etbreak"..i end

function BulletBreak:init(x,y,index)
	self.x=x
	self.y=y
	self.group=GROUP_GHOST
	self.layer=LAYER_ENEMY_BULLET-50
	self.img=BulletBreak_Image[index]
	local s = ran:Float(0.5,0.75)
	self.hscale=s self.vscale=s
	self.rot=ran:Float(0,360)
end

function BulletBreak:frame()
	if self.timer>=23 then
		self.status="del"
	end
end


---基础弹型class，弹雾效果的实现
img_class=Class(object)

function img_class:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-self.imgclass.size*0.001+self._index*0.00001
		if self.stay then
			self.timer=-1
		end
	end
end

function img_class:del()
	New(bubble2,"preimg"..self.index,
			self.x,self.y,
			self.dx,self.dy,
			11,self.imgclass.size*max(self.hscale,self.vscale),0,
			Color(0xFFFFFFFF),Color(0xFFFFFFFF),self.layer,"mul+add")
end

function img_class:kill()
	img_class.del(self)
	New(item_faith_minor,self.x,self.y)
end

local _scale={}
local _fogcolor={}
for i=0,12 do
	_scale[i]=(11-i)/11*3+1
	_fogcolor[i]=Color(255*(i/11),255,255,255)
end

function img_class:render()
	local img="preimg"..self._index--16色
	--local img="preimg"..self.index--8色
	local s=_scale[self.timer]*self.imgclass.size
	if self._blend then
		SetImageState(img,self._blend,_fogcolor[i])
	else
		SetImageState(img,"",_fogcolor[self.timer])
	end
	Render(img,self.x,self.y,self.rot,s*self.hscale,s*self.vscale)
end
