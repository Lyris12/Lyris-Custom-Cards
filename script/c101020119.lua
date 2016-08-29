--Blitz Field
function c101020119.initial_effect(c)
	--If this card is destroyed: Destroy all monsters you control.
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,101020119)
	e4:SetTarget(c101020119.destg)
	e4:SetOperation(c101020119.desop)
	c:RegisterEffect(e4)
	--You can destroy 1 "Blitzkrieg" monster in your hand or face-up in your Monster Zone, then apply 1 of the following effects.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,201020119)
	e2:SetTarget(c101020119.target)
	e2:SetOperation(c101020119.operation)
	c:RegisterEffect(e2)
end
function c101020119.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101020119.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c101020119.filter(c)
	return c:IsSetCard(0x167) and (c:IsFaceup() or c:IsType(TYPE_MONSTER)) and c:IsDestructable()
end
function c101020119.efilter1(c,n)
	if not c:IsType(TYPE_MONSTER) or not c:IsSetCard(0x167) then return false end
	if n~=0 then
		return c:IsAbleToDeck()
	else return c:IsAbleToHand() end
end
function c101020119.efilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c101020119.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020119.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and (Duel.IsExistingMatchingCard(c101020119.efilter1,tp,LOCATION_DECK,0,1,nil,0)
		or Duel.IsExistingMatchingCard(c101020119.efilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingMatchingCard(c101020119.efilter1,tp,LOCATION_REMOVED,0,1,nil,1)) end
	local op=Duel.SelectOption(tp,aux.Stringid(101020119,0),aux.Stringid(101020119,1),aux.Stringid(101020119,2))
	e:SetLabel(op)
end
function c101020119.efilter3(c,tc)
	return c101020119.efilter1(c,0) and c:GetCode()~=tc:GetCode()
end
function c101020119.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101020119.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		if e:GetLabel()==0 then
			--Add 1 "Blitzkrieg" monster from your Deck to your hand, except the monster destroyed by this effect.
			local tg=Duel.SelectMatchingCard(tp,c101020119.efilter3,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
			if tg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		elseif e:GetLabel()==1 then
			--Destroy 1 Spell/Trap Card on the field.
			local tg=Duel.SelectMatchingCard(tp,c101020119.efilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if tg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.HintSelection(tg)
				Duel.Destroy(tg,REASON_EFFECT)
			end
		else
			--Shuffle 1 of your banished "Blitzkrieg" monsters into the Deck.
			local tg=Duel.SelectMatchingCard(tp,c101020119.efilter1,tp,LOCATION_DECK,0,1,1,nil,1)
			if tg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
			end
		end
	end
end