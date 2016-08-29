--PSYStream Whale
function c101010109.initial_effect(c)
c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	--If this card inflicts battle damage to your opponent: You can banish 1 "PSYStream" card from your Graveyard. --During the next End Phase, add that card to your hand.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_BATTLE_DAMAGE)
	e0:SetCondition(c101010109.rmcon)
	e0:SetTarget(c101010109.rmtg)
	e0:SetOperation(c101010109.rmop)
	c:RegisterEffect(e0)
	--If this card is banished: You can target any number of your other banished "PSYStream" monsters; shuffle them into the Deck, and if you do, their Levels become 3 while in the Main Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) local ef=e:GetHandler():GetReasonEffect() return ef and ef:GetHandler():IsSetCard(0x127) end)
	e1:SetTarget(c101010109.rettg)
	e1:SetOperation(c101010109.retop)
	c:RegisterEffect(e1)
	--This card can attack your opponent directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--If this card attacks directly, any battle damage your opponent takes becomes 1200 if the amount is more than than 1400.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c101010109.rdcon)
	e3:SetOperation(c101010109.rdop)
	c:RegisterEffect(e3)
end
function c101010109.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and ev>1400
end
function c101010109.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,1200)
end
function c101010109.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101010109)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101010109.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c101010109.filter2(c)
	return c:IsSetCard(0x127) and c:IsAbleToRemove() and c:GetCode()~=101010109
end
function c101010109.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010109.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c101010109.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010109.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		--During the next End Phase, add that card to your hand.
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetLabel(0)
		e1:SetOperation(c101010109.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010109.desop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetLabel()+1)
	if e:GetLabel()>=2 then
		Duel.Hint(HINT_CARD,0,101010109)
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c101010109.filter(c)
	return c:IsSetCard(0x127) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101010109.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010109.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010109.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101010109.filter,tp,LOCATION_REMOVED,0,1,99,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c101010109.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if ct>0 and tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(3)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
	end
end
