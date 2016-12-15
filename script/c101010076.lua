--created & coded by Lyris
--Crystapal Lyris the Emerald
function c101010076.initial_effect(c)
aux.EnablePendulumAttribute(c)
	--If a player adds a Spell Card(s) to their hand, except by drawing: excavate cards from the top of your Deck until you excavate a "Liquid Crystapal" monster, Special Summon that card to that player's field, then repeat this effect up to a number of times equal to the number of Spell Cards they added - 1. After this effect resolves, shuffle all excavated cards not Summoned by that effect into the Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101010076.spcon)
	e2:SetTarget(c101010076.sumtg)
	e2:SetOperation(c101010076.sumop)
	c:RegisterEffect(e2)
end
function c101010076.cfilter(c)
	return not c:IsReason(REASON_DRAW) and c:IsType(TYPE_SPELL)
end
function c101010076.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ap=eg:GetFirst():GetControler()
	return not eg:IsExists(Card.IsControler,1,nil,1-ap) and eg:IsExists(c101010076.cfilter,1,nil)
end
function c101010076.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010076.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,eg:GetFirst():GetControler(),LOCATION_DECK)
end
function c101010076.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=eg:Filter(c101010076.cfilter,nil)
	local p=c:GetControler()
	local ap=eg:GetFirst():GetControler()
	local sg=Duel.GetMatchingGroup(c101010076.filter,p,LOCATION_DECK,0,nil,e,ap)
	local ft1=Duel.GetLocationCount(ap,LOCATION_MZONE)
	local ct=mg:GetCount()
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
