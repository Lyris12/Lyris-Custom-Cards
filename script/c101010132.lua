--During your opponent's turn: Special Summon this card as an Effect Monster Card with every Attribute (Dragon-Type/Level 5/2600 ATK/1500 DEF). (This card is NOT treated as a Trap Card.) If this card is targeted by your opponent: Destroy this Card.
--襲雷神－ズース
function c101010132.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101010132.spcon)
	e1:SetTarget(c101010132.sptg)
	e1:SetOperation(c101010132.spop)
	c:RegisterEffect(e1)
end
function c101010132.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer~=tp
end
function c101010132.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_HAND,0,1,3,nil)
	e:SetLabel(g:GetCount())
	Duel.Destroy(g,REASON_COST)
end
function c101010132.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,101010132,0x167,0x21,2600,1400,6,RACE_DRAGON,0xff) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010132.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101010132,0x167,0x21,2600,1400,6,RACE_DRAGON,0xff) then
		c:AddMonsterAttribute(TYPE_EFFECT,0xff)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		--effects
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_BE_BATTLE_TARGET)
		e3:SetCountLimit(1,101010132)
		e3:SetOperation(c101010132.deslop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
		e4:SetCode(EVENT_CHAINING)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(c101010132.deslcon)
		c:RegisterEffect(e4)
		--[[local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_ATTACK)
		e0:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(-e:GetLabel())
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e5:SetCountLimit(1,101010132)
		e5:SetCondition(c101010132.descon)
		e5:SetTarget(c101010132.destg)
		e5:SetOperation(c101010132.desop)
		c:RegisterEffect(e5)]]
		Duel.SpecialSummonComplete()
	end
end
function c101010132.deslcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c101010132.deslop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
