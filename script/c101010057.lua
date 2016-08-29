--旋風のストーム
function c101010057.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101010057.tg)
	e1:SetOperation(c101010057.op)
	c:RegisterEffect(e1)
end
function c101010057.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd5d)
end
function c101010057.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101010057.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101010057.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c101010057.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010057.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010057.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(c101010057.cfilter,tp,LOCATION_MZONE,0,1,nil) then lc=LOCATION_DECK end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT,lc)~=0
		and tc:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tc:GetControler())
	end
end
