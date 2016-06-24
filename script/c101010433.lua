--ＳーＶｉｎｅ(セイクリド・ヴァイン)の騎士－クライッシャ
local id,ref=GIR()
function ref.initial_effect(c)
	--Once per turn, during either player's turn: You can banish 1 card from your hand, then target 1 card on the field, then apply the effect based on its type. (If the target is Set, reveal it first.) ● Monster: Banish it. ● Spell: Shuffle it into the Deck. ● Trap: Return it to the hand.
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_QUICK_O)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_FREE_CHAIN)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(ref.cost)
	ae1:SetTarget(ref.tg)
	ae1:SetOperation(ref.op)
	c:RegisterEffect(ae1)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.spatial=true
--Spatial Formula filter(s)
ref.material1=function(mc) return mc:IsSetCard(0x785a) or mc:IsSetCard(0x53) end
-- ref.material2=function(mc) return true end -- Invert this block of code on Division Spatial Monsters (begin)
-- ref.addt_spatial=true ref.subt_spatial=true ref.mult_spatial=true --choose 1, depending on the Spatial Formula
ref.divs_spatial=true --Division Procedure /
ref.stat=function(mc) return mc:GetAttack() end
ref.indicator=function(mc) return mc:GetLevel() end -- Invert this block of code on Division Spatial Monsters (end)
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.tfilter(c,e)
	return c:IsCanBeEffectTarget(e) and ref.filter(c,c:GetOriginalType())
end
function ref.filter(c,typ)
	if bit.band(typ,TYPE_MONSTER)==TYPE_MONSTER then
		return c:IsAbleToRemove()
	elseif bit.band(typ,TYPE_SPELL)==TYPE_SPELL then
		return c:IsAbleToDeck()
	else return c:IsAbleToHand() end
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,ref.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
	local cat=CATEGORY_TOHAND
	if bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER then cat=CATEGORY_REMOVE elseif bit.band(g:GetFirst():GetOriginalType(),TYPE_SPELL)==TYPE_SPELL then cat=CATEGORY_TODECK end
	e:SetCategory(cat)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,cat,g,1,0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
		if tc:IsType(TYPE_MONSTER) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
		if tc:IsType(TYPE_SPELL) then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) end
		if tc:IsType(TYPE_TRAP) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	end
end
