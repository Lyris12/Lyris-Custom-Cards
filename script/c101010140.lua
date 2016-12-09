--created & coded by Lyris
--Fate's Necro Lord
function c101010140.initial_effect(c)
	--If this card is Special Summoned from the hand or with a "Fate's" card: You can target 1 monster your opponent controls; banish it until the end of this turn. If this card was Pendulum Summoned, you must have a "Fate's" card in your Pendulum Zone to activate this effect. You can only use this effect of "Fate's Necro Lord" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101010140)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCondition(c101010140.condition)
	e1:SetTarget(c101010140.target)
	e1:SetOperation(c101010140.operation)
	c:RegisterEffect(e1)
end
function c101010140.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		return pc1:IsSetCard(0xf7a) or pc2:IsSetCard(0xf7a)
	end
	return c:GetSummonLocation()==LOCATION_HAND or re:GetHandler():IsSetCard(0xf7a)
end
function c101010140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	e:SetCategory(CATEGORY_REMOVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101010140.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c101010140.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010140.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
