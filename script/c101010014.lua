--旋風のフェザーマン
local id,ref=GIR()
function ref.start(c)
local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,id)
	e0:SetCode(EVENT_TO_DECK)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsReason(REASON_EFFECT+REASON_MATERIAL) end)
	e0:SetTarget(ref.drtg)
	e0:SetOperation(ref.drop)
	c:RegisterEffect(e0)
end
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0xd5d)~=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	while Duel.Draw(tp,1,REASON_EFFECT)~=0 do
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsSetCard(0xd5d) then
			if tc:IsType(TYPE_MONSTER) then
				Duel.SendtoDeck(tc,nil,2,0)
				Duel.MoveSequence(tc,1)
			end
		else Duel.ShuffleHand(tp) return end
	end
end
