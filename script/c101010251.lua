--Fate HERO Jester's Apprentice
function c101010251.initial_effect(c)
--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010251,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101010251.actcon)
	e2:SetTarget(c101010251.acttg)
	e2:SetOperation(c101010251.act)
	c:RegisterEffect(e2)
	--on-destruct
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c101010251.settg)
	e4:SetOperation(c101010251.setop)
	c:RegisterEffect(e4)
end
function c101010251.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,0)
end
function c101010251.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xf7a) then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then Duel.SSet(tp,tc) end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c101010251.filter(c)
	return c:IsSetCard(0xf7a) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_RITUAL)
end
function c101010251.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101010251.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c101010251.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c101010251.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
c101010251.after=function(e,tp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	c101010251.act(e,tp)
end
