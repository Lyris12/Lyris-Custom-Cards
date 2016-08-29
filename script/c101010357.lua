--Victorial Dragon Sagitton
function c101010357.initial_effect(c)
c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x50b),2,64,true)
	--spsum condition
	local rl=Effect.CreateEffect(c)
	rl:SetType(EFFECT_TYPE_SINGLE)
	rl:SetCode(EFFECT_SPSUMMON_CONDITION)
	rl:SetRange(LOCATION_EXTRA)
	rl:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	rl:SetValue(c101010357.splimit)
	c:RegisterEffect(rl)
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(function(e,c) return c:IsFaceup() and c:IsLevelBelow(5) end)
	c:RegisterEffect(e1)
	--dispose
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(1)
	e2:SetTarget(c101010357.reptg)
	e2:SetValue(c101010357.repval)
	c:RegisterEffect(e2)
	if not relay_check then
		relay_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010357.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010357.relay=true
c101010357.point=3
function c101010357.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function c101010357.splimit(e,se,sp,st)
	return c:IsFaceup() and bit.band(st,0x8773)==0x8773 or aux.fuslimit(e,se,sp,st)
end
function c101010357.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x50b)
end
function c101010357.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return eg:IsExists(c101010357.repfilter,1,nil,tp) end
	if c:GetFlagEffect(10001100)>=ct and Duel.SelectYesNo(tp,aux.Stringid(101010357,1)) then
		if point==ct then
			c:ResetFlagEffect(10001100)
		else
			c:SetFlagEffectLabel(10001100,point-ct)
		end
		return true
	else return false end
end
function c101010357.repval(e,c)
	return c101010357.repfilter(c,e:GetHandlerPlayer())
end
