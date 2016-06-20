--旋風のヘルダイブ・スラッシャー
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0x144,0x144)
	e1:SetCondition(ref.con)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.act)
	c:RegisterEffect(e1)
end
function ref.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function ref.cfilter2(c)
	return c:IsFaceup() and (c:IsCode(82044279) or c:IsCode(50954680) or c:IsSetCard(0x17) or c:IsSetCard(0x92b))
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(ref.cfilter1,tp,LOCATION_MZONE,0,1,nil)
	and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.IsExistingMatchingCard(ref.cfilter2,tp,LOCATION_ONFIELD,0,1,nil))
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetReset(RESET_EVENT+0x1fe0000)
	tc:GetFirst():RegisterEffect(e0)
	local dis=e0:Clone()
	dis:SetCode(EFFECT_DISABLE_EFFECT)
	tc:GetFirst():RegisterEffect(dis)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function ref.act(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
