--Spectrum Piece Test General 1
function c101010211.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101010211.spptg)
	e1:SetOperation(c101010211.sppop)
	c:RegisterEffect(e1)
end
function c101010211.spptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(e:GetHandler():GetControler(),10008000)==0 end
end
function c101010211.sppop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local red=Duel.GetFlagEffect(p,10001000)
	local orange=Duel.GetFlagEffect(p,10002000)
	local yellow=Duel.GetFlagEffect(p,10003000)
	local green=Duel.GetFlagEffect(p,10004000)
	local blue=Duel.GetFlagEffect(p,10005000)
	local indigo=Duel.GetFlagEffect(p,10006000)
	local purple=Duel.GetFlagEffect(p,10007000)
	if Duel.GetFlagEffect(p,10008000)~=0 then Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(450,0)) return end
	local t={[1]=red,[2]=orange,[3]=yellow,[4]=green,[5]=blue,[6]=indigo,[7]=purple}
	--[[local chcs={}
	local i=1
	local pos=1
	local i=1
	for i=1,7 do
		if t[i]~=0 then
			chcs[pos]=aux.Stringid(450,i)
		else chcs[pos]=aux.Stringid(450,8) end
		pos=pos+1
	end
	chcs[pos]=nil]]
	local pcs=10000000+((Duel.SelectOption(p,aux.Stringid(450,1),aux.Stringid(450,2),aux.Stringid(450,3),aux.Stringid(450,4),aux.Stringid(450,5),aux.Stringid(450,6),aux.Stringid(450,7))+1)*1000)
	while Duel.GetFlagEffect(p,pcs)~=0 do
		pcs=10000000+((Duel.SelectOption(p,aux.Stringid(450,1),aux.Stringid(450,2),aux.Stringid(450,3),aux.Stringid(450,4),aux.Stringid(450,5),aux.Stringid(450,6),aux.Stringid(450,7))+1)*1000)
	end
	Duel.RegisterFlagEffect(p,pcs,0,0,1)
	if red+orange+yellow+green+blue+indigo+purple+1==7 then
		Duel.RegisterFlagEffect(tp,10008000,0,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1)
		Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(450,0))
	end
end
