--ＳーＶｉｎｅ(セイクリド・ヴァイン)の騎士－クライッシャ
function c101010433.initial_effect(c)
	--Once per turn, during either player's turn: You can banish 1 card from your hand, then target 1 card on the field, then apply the effect based on its type. (If the target is Set, reveal it first.) ● Monster: Banish it. ● Spell: Shuffle it into the Deck. ● Trap: Return it to the hand.
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_QUICK_O)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_FREE_CHAIN)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010433.cost)
	ae1:SetTarget(c101010433.tg)
	ae1:SetOperation(c101010433.op)
	c:RegisterEffect(ae1)
	if not c101010433.global_check then
		c101010433.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010433.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010433.spatial=true
--Spatial Formula filter(s)
c101010433.material=function(mc) return mc:IsSetCard(0x785a) or mc:IsSetCard(0x53) end
c101010433.dimension_loss=2
function c101010433.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
function c101010433.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010433.tfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c101010433.filter(c,c:GetOriginalType())
end
function c101010433.filter(c,typ)
	if bit.band(typ,TYPE_MONSTER)==TYPE_MONSTER then
		return c:IsAbleToRemove()
	elseif bit.band(typ,TYPE_SPELL)==TYPE_SPELL then
		return c:IsAbleToDeck()
	else return c:IsAbleToHand() end
end
function c101010433.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101010433.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
	local tc=g:GetFirst()
	Duel.SetTargetCard(g)
	if tc:IsFaceup() or tc:IsLocation(LOCATION_MZONE) then
		local cat=CATEGORY_TOHAND
		if bit.band(tc:GetType(),TYPE_MONSTER)==TYPE_MONSTER then cat=CATEGORY_REMOVE elseif bit.band(tc:GetType(),TYPE_SPELL)==TYPE_SPELL then cat=CATEGORY_TODECK end
		e:SetCategory(cat)
		Duel.SetOperationInfo(0,cat,g,1,0,0)
	end
end
function c101010433.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
		if tc:IsType(TYPE_MONSTER) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
		if tc:IsType(TYPE_SPELL) then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) end
		if tc:IsType(TYPE_TRAP) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	end
end
