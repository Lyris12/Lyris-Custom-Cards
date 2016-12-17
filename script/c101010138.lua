--Crystapal Hiro the Pearl
function c101010138.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--After the effect of a Spell Card in a player's Spell & Trap Zone resolves: Excavate cards from the top of your Deck until you excavate a "Liquid Crystapal" monster, that player Special Summons that card to their field, also, shuffle all excavated cards not Summoned by this effect back into the Deck.local e1=Effect.CreateEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(c101010138.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+101010138)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetLabelObject(e1)
	e2:SetOperation(c101010138.sumcon)
	e2:SetTarget(c101010138.sumtg)
	e2:SetOperation(c101010138.sumop)
	c:RegisterEffect(e2)
end
function c101010138.chop1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_SPELL) or re:GetActivateLocation()~=LOCATION_SZONE or re:GetHandler():GetSequence()>4 then return end
	e:SetLabelObject(re:GetHandler())
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+101010138,e,r,rp,re:GetHandlerPlayer(),0)
end
function c101010138.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010138.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010138.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x1613)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	Duel.SpecialSummon(spcard,0,ep,ep,false,false,POS_FACEUP)
end
