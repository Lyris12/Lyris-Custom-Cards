--While this card in your hand is revealed, you can Normal Summon 1 LIGHT monster from your hand as an additional Normal Summon. During your Draw Phase, instead of conducting your normal draw: you can reveal this card in your hand until the End Phase; Excavate the top 5 cards of your deck, and if there is a "Radiant" card among them, add all of the excavated cards to your hand, and if you do, reveal all non-"Radiant" cards excavated. You can only use this effect of "Radiant Angel" once per turn.
--炯然エンジェル
local id,ref=GIR()
function ref.start(c)
--summon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1)
	e0:SetCondition(ref.sumcon)
	e0:SetTarget(ref.sumtg)
	e0:SetOperation(ref.sumop)
	c:RegisterEffect(e0)
	--reveal
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,id)
	e1:SetCondition(ref.condition1)
	e1:SetCost(ref.cost)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
end
function ref.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(tp)>0
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function ref.filter(c)
	return c:IsSetCard(0x5e) and c:GetCode()~=id
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x5e)
	end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)   
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:IsExists(Card.IsSetCard,1,nil,0x5e) then
		local tc=g:GetFirst()
		while tc do
			if tc:IsAbleToHand() then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
			else
				Duel.SendtoGrave(tc,REASON_RULE)
			end
			tc=g:GetNext()
		end
		Duel.ShuffleDeck(tp)
	else
		Duel.ShuffleDeck(tp)
	end
end
function ref.sumcon(e)
	return e:GetHandler():IsPublic()
end
function ref.sumfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSummonable(true,nil) and c:IsLevelBelow(4)
end
function ref.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(ref.sumfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function ref.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.sumfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
