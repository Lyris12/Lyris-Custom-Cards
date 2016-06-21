--炯然スパーク
local id,ref=GIR()
function ref.start(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(ref.cost)
	e0:SetTarget(ref.target)
	e0:SetOperation(ref.activate)
	c:RegisterEffect(e0)
	--revealed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetCondition(ref.condition)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
end
function ref.condition(e)
	return e:GetHandler():IsPublic()
end
function ref.cfilter(c)
	return c:IsSetCard(0x5e) and not c:IsPublic()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
function ref.filter(c)
	return c:IsSetCard(0x5e) and c:GetCode()~=id and c:IsAbleToHand()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
