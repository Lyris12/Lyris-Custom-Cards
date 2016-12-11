--created & coded by Lyris
--Fate's Charity
function c101010120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101010120.cost)
	e1:SetTarget(c101010120.target)
	e1:SetOperation(c101010120.activate)
	c:RegisterEffect(e1)
end
function c101010120.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf7a)
end
function c101010120.cfilter(c,tp)
	return c:IsSetCard(0xf7a) and c:IsDiscardable()
end
function c101010120.star(c)
	return c:IsFaceup() and c:IsHasEffect(101010187) and c:IsReleasableByEffect()
end
function c101010120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c101010120.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
	local b2=Duel.CheckReleaseGroup(tp,c101010120.star,1,nil)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101010120.filter,1,nil) and (b1 or b2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101010120.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.BreakEffect()
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(101010187,0))) then
		Duel.DiscardHand(tp,c101010120.cfilter,1,1,REASON_COST+REASON_DISCARD)
	else
		local star=Duel.SelectReleaseGroup(tp,c101010120.star,1,1,nil)
		Duel.Release(star,REASON_COST)
	end
end
function c101010120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101010120.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
