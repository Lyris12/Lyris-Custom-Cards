--F・HEROジュリーガイ
function c101010200.initial_effect(c)
c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010200,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101010200.actcon)
	e2:SetCost(c101010200.actcost)
	e2:SetTarget(c101010200.acttg)
	e2:SetOperation(c101010200.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101010200,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	--e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(0xff,0xff)
	e4:SetTarget(function(e,c) return bit.band(c:GetReason(),REASON_RELEASE)==REASON_RELEASE end)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
end
function c101010200.mat_filter(c)
	return c:GetLevel()~=10
end
function c101010200.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010091)~=0
end
function c101010200.cfilter(c)
	return c:IsReleasableByEffect() and (c:IsLevelBelow(9) or (c:IsCode(101010187) and c:IsHasEffect(101010187)))
end
function c101010200.star(c)
	return c:IsCode(101010187) and c:IsHasEffect(101010187)
end
function c101010200.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c101010200.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if chk==0 then return cg:IsExists(c101010200.star,1,nil) or cg:CheckWithSumEqual(Card.GetLevel,12,1,99) end
	local g=nil
	if not cg:CheckWithSumEqual(Card.GetLevel,12,1,99) or (cg:IsExists(c101010200.star,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101010200,0))) then
		g=cg:FilterSelect(tp,c101010200.star,1,1,nil)
	else
		g=cg:SelectWithSumEqual(tp,Card.GetLevel,12,1,99)
	end
	Duel.Release(g,REASON_COST)
end
function c101010200.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010200.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		c:CompleteProcedure()
		c101010200.after(e,tp)
	end
end
function c101010200.after(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c101010200.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010200.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(4) or (c:IsRankAbove(4) and c:IsType(TYPE_XYZ))
end
