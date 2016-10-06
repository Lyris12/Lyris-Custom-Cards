--Spectrum Piece Test Add
function c101010324.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101010324.spptg)
	e1:SetOperation(c101010324.sppop)
	c:RegisterEffect(e1)
end
function c101010324.spptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(e:GetHandler():GetControler(),10007000)==0 end
end
function c101010324.sppop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local red=Duel.GetFlagEffect(p,10001000)
	local orange=Duel.GetFlagEffect(p,10002000)
	local yellow=Duel.GetFlagEffect(p,10003000)
	local green=Duel.GetFlagEffect(p,10004000)
	local blue=Duel.GetFlagEffect(p,10005000)
	local indigo=Duel.GetFlagEffect(p,10006000)
	local purple=Duel.GetFlagEffect(p,10007000)
	if Duel.GetFlagEffect(p,10008000)~=0 then Duel.Hint(HINT_MESSAGE,0,aux.Stringid(450,0)) return end
	if purple==0 then
		Duel.RegisterFlagEffect(p,10007000,0,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1)
		if red+orange+yellow+green+blue+indigo+1==7 then
			Duel.RegisterFlagEffect(tp,10008000,0,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1)
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(450,0))
		end
	end
end
