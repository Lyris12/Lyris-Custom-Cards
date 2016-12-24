--created & coded by Lyris
--Crystapal Avzin the Diamond
function c101010137.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--If a player draws a Trap Card(s): that player reveals that card(s); excavate cards from the top of your Deck until you excavate a "Liquid Crystapal" monster, Special Summon that card to that player's field, then repeat this effect up to a number of times equal to the number of cards they revealed - 1. After this effect resolves, shuffle all excavated cards not Summoned by that effect into the Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101010137.spcon)
	e2:SetTarget(c101010137.sumtg)
	e2:SetOperation(c101010137.sumop)
	c:RegisterEffect(e2)
end
function c101010137.cfilter(c)
	return c:IsType(TYPE_TRAP) and not c:IsPublic()
end
function c101010137.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101010137.cfilter,1,nil) and not eg:IsExists(Card.IsControler,1,nil,1-eg:GetFirst():GetControler())
end
function c101010137.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ap=eg:GetFirst():GetControler()
	local g=eg:Filter(Card.IsType,nil,TYPE_TRAP)
	Duel.ConfirmCards(1-ap,g)
	Duel.ShuffleHand(ap)
	e:SetLabel(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_NONE,LOCATION_DECK)
end
function c101010137.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010137.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p=c:GetControler()
	local ap=eg:GetFirst():GetControler()
	local sg=Duel.GetMatchingGroup(c101010137.filter,p,LOCATION_DECK,0,nil,e,ap)
	local ft1=Duel.GetLocationCount(ap,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft1>0 then
		local dcount=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
		if sg:GetCount()==0 then
			Duel.ConfirmDecktop(p,dcount)
			Duel.ShuffleDeck(p)
			return
		end
		if ct>ft1 then ct=ft1 end
		local dc=nil
		while dcount>0 and ct>0 do
			Duel.ConfirmDecktop(p,1)
			dc=Duel.GetDecktopGroup(p,1):GetFirst()
			if sg:IsContains(dc) then
				Duel.SpecialSummonStep(dc,0,ap,ap,false,false,POS_FACEUP)
				ct=ct-1
			else
				Duel.MoveSequence(dc,1)
			end
			dcount=dcount-1
		end
		Duel.SpecialSummonComplete()
	end
end
