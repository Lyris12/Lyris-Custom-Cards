--created & coded by Lyris
--クリスタ・ケーヴ
function c101010300.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_SZONE,0)
	e6:SetTarget(c101010300.pendulum)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(101010300,0))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,101010300)
	e7:SetTarget(c101010300.thtg)
	e7:SetOperation(c101010300.thop)
	c:RegisterEffect(e7)
end
function c101010300.pendulum(e,c)
	local seq=c:GetSequence()
	return seq==7 or seq==6
end
function c101010300.filter(c)
	return c:IsSetCard(0x1613) and c:IsDestructable()
end
function c101010300.thfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101010300.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010300.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101010300.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c101010300.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010300.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010300.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101010300.thfilter,tp,LOCATION_DECK,0,nil)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
