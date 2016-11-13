--created & coded by Lyris
--Flame Flight - Penguin
function c101010106.initial_effect(c)
--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--removal
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(c101010106.con)
	e0:SetTarget(c101010106.target)
	e0:SetOperation(c101010106.op)
	c:RegisterEffect(e0)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101010106.ffilter1,c101010106.ffilter2,true)
end
function c101010106.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) or (c:IsHasEffect(101010012) and not c:IsLocation(LOCATION_DECK))
end
function c101010106.ffilter2(c)
	return c:IsRace(RACE_AQUA+RACE_WINDBEAST) or (c:IsHasEffect(101010085) and not c:IsLocation(LOCATION_DECK))
end
function c101010106.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and (c:IsType(TYPE_FUSION))
end
function c101010106.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsHasEffect(101010055) then
		if bit.band(c:GetPosition(),POS_FACEUP_DEFENSE)==0 then return false end
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and tg and tg:IsExists(c101010106.filter,1,nil) and Duel.IsChainNegatable(ev)
end
function c101010106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101010106.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	Duel.BreakEffect()
	Duel.NegateActivation(ev)
	if ec:IsType(TYPE_SPELL+TYPE_TRAP) then ec:CancelToGrave() end
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end
