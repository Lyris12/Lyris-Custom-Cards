--any amount of LP in multiples of 100
--Flame Flight Dragon - Friday
function c101010559.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),aux.FilterBoolFunction(c101010559.ffilter),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010559,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c101010559.con)
	e2:SetCost(c101010559.cost)
	e2:SetOperation(c101010559.op)
	c:RegisterEffect(e2)
end
function c101010559.ffilter(c)
	return c:IsType(TYPE_FUSION) and (c:IsAttribute(ATTRIBUTE_FIRE) or (c:IsHasEffect(101010560) and not c:IsLocation(LOCATION_DECK)))
end
function c101010559.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c101010559.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=Duel.GetLP(tp)
	local lp=Duel.GetLP(1-tp)
	local c=e:GetHandler()
	if chk==0 then
		if c:IsHasEffect(101010552) then return true end
		return lp<lv
	end
	local t={}
	local i=1
	local p=1
	local d=math.floor((lv-lp)/100)
	if c:IsHasEffect(101010552) then d=20 end
	for i=1,d do
		t[p]=i p=p+1
		if p>20 then break end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010559,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t))*100)
	Duel.PayLPCost(tp,e:GetLabel())
end
function c101010559.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lp)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end