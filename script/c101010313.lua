--Vicarious Summoning
function c101010313.initial_effect(c)
	--Return all monsters whose controllers are different from their owners to the hand, then each player can Special Summon 1 monster that was returned this way from their hand or Extra Deck to their side of the field.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c101010313.target)
	e0:SetOperation(c101010313.activate)
	c:RegisterEffect(e0)
	--If possession of a monster(s) switches from their owners': that player's opponent can add this card from your Deck or either player's Graveyard to their hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CONTROL_CHANGED)
	e1:SetRange(LOCATION_GRAVE+LOCATION_DECK)
	e1:SetOperation(c101010313.stcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_CUSTOM+101010313)
	e2:SetTarget(c101010313.sttg)
	e2:SetOperation(c101010313.stop)
end
function c101010313.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) or not c:IsControler(tp) then
		local tc=eg:GetFirst()
		local tp1=false local tp2=false
		while tc do
			if tc:GetOwner()~=tc:GetControler() then
				if tc:IsControler(tp) then tp2=true else tp1=true end
			end
			tc=eg:GetNext()
		end
		if tp1 then Duel.RaiseSingleEvent(c,101010313,e,r,rp,tp,0) end
		if tp2 then Duel.RaiseSingleEvent(c,101010313,e,r,rp,1-tp,0) end
	end
end
function c101010313.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsRelateToEffect(e) and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c101010313.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c101010313.filter(c)
	return c:GetOwner()~=c:GetControler() and c:IsAbleToHand()
end
function c101010313.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010313.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c101010313.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c101010313.spfilter(c,e,p)
	return c:IsLocation(LOCATION_HAND+LOCATION_EXTRA) and c:IsControler(p) and c:IsCanBeSpecialSummoned(e,0,p,false,false)
end
function c101010313.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c101010313.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	local pg=rg:Filter(c101010313.spfilter,nil,e,tp)
	local og=rg:Filter(c101010313.spfilter,nil,e,1-tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and pg:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(101010313,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=pg:Select(tp,1,1,nil)
		Duel.SpecialSummonStep(g1:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and og:GetCount()>0
		and Duel.SelectYesNo(1-tp,aux.Stringid(101010313,1)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g2=og:Select(1-tp,1,1,nil)
		Duel.SpecialSummonStep(g2:GetFirst(),0,1-tp,1-tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
