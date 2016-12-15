--Crystapal Nikos the Amethyst
function c101010180.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--After the effect of a Trap Card resolves: Excavate cards from the top of your Deck until you excavate a "Liquid Crystapal" monster, that player Special Summons that card to their field, also, shuffle all excavated cards not Summoned by this effect back into the Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(c101010180.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetOperation(c101010180.sumcon)
	e2:SetTarget(c101010180.sumtg)
	e2:SetOperation(c101010180.sumop)
	c:RegisterEffect(e2)
end
function c101010180.sumcon(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabelObject(re:GetHandler())
	return re:IsActiveType(TYPE_TRAP)
end
function c101010180.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010180.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010180.filter,e:GetHandler():GetControler(),LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010180.sumop
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
	Duel.SpecialSummon(spcard,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
