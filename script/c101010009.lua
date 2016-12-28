--created & coded by Lyris
--PSYストリーム・キマイラ
function c101010009.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,101010009)
	e0:SetTarget(c101010009.negtg)
	e0:SetOperation(c101010009.negop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) local ef=e:GetHandler():GetReasonEffect() return ef and ef:GetHandler():IsSetCard(0x127) end)
	e1:SetTarget(c101010009.target)
	e1:SetOperation(c101010009.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c101010009.rdcon)
	e3:SetOperation(c101010009.rdop)
	c:RegisterEffect(e3)
end
function c101010009.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and ev>900
end
function c101010009.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,500)
end
function c101010009.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x127)
end
function c101010009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010009.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010009.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101010009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101010009.negfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c101010009.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101010009.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010009.negfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SelectTarget(tp,c101010009.negfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101010009.negop(e,tp,eg,ep,ev,re,r,rp)
	local dr=Duel.GetFieldCard(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(1-tp,dr)
	Duel.ConfirmCards(tp,dr)
	if dr:IsSetCard(0x127) and Duel.SendtoHand(dr,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,dr)
		Duel.ShuffleHand(tp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
