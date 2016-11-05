--F・HEROマジックガイ
function c101010187.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD) end)
	e1:SetCode(101010187)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010187,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,101010187)
	e2:SetTarget(c101010187.acttg)
	e2:SetOperation(c101010187.act)
	c:RegisterEffect(e2)
end
function c101010187.filter(c,tp)
	return c:GetType()==0x82 and (c:IsLocation(LOCATION_REMOVED) or (c:IsControler(tp) and c:IsSetCard(0xf7a)))
end
function c101010187.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010187.filter,tp,LOCATION_DECK+LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101010187.act(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010187.filter,tp,LOCATION_DECK+LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
c101010187.after=function(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010187.filter,tp,LOCATION_DECK+LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) end
	c101010187.act(e,tp)
end