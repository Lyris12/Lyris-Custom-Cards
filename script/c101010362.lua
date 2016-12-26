--Crystapal Dharc the Tourmaline
function c101010362.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--If a player Summons a non-"Liquid Crystapal" monster(s): Excavate cards from the top of your Deck until you excavate a "Liquid Crystapal" monster, add that card to that player's hand, then repeat this effect up to a number of times equal to the number of monsters they Summoned - 1. After this effect resolves, shuffle all excavated cards not added by that effect back into the Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCondition(c101010362.spcon)
	e1:SetTarget(c101010362.sumtg)
	e1:SetOperation(c101010362.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101010362.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x1613)
end
function c101010362.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ap=eg:GetFirst():GetControler()
	return not eg:IsExists(Card.IsControler,1,nil,1-ap) and eg:IsExists(c101010362.cfilter,1,nil)
end
function c101010362.filter(c)
	return c:IsSetCard(0x1613) and c:IsAbleToHand()
end
function c101010362.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,eg:GetFirst():GetControler(),LOCATION_DECK)
end
function c101010362.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p=c:GetControler()
	local mg=eg:Filter(c101010362.cfilter,nil)
	local ap=eg:GetFirst():GetControler()
	local sg=Duel.GetMatchingGroup(c101010362.filter,p,LOCATION_DECK,0,nil)
	local ct=mg:GetCount()
	local dcount=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	if dcount==0 then return end
	if sg:GetCount()==0 then
		Duel.ConfirmDecktop(p,dcount)
		Duel.ShuffleDeck(p)
		return
	end
	local dc=nil
	local ag=Group.CreateGroup()
	while dcount>0 and ct>0 do
		Duel.ConfirmDecktop(p,1)
		dc=Duel.GetDecktopGroup(p,1):GetFirst()
		if sg:IsContains(dc) then
			if dc:IsAbleToHand() then
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(dc,ap,REASON_EFFECT)
				ag:AddCard(dc)
			else Duel.SendtoGrave(dc,REASON_RULE) end
			ct=ct-1
		else
			Duel.MoveSequence(dc,1)
		end
		dcount=dcount-1
	end
	Duel.ConfirmCards(1-ap,ag)
	Duel.ShuffleHand(ap)
end
