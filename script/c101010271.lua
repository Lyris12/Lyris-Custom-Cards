--created & coded by Lyris
--制勝竜♍
function c101010271.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler() local ct=c:GetFlagEffectLabel(10001000) if not ct then c:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1) else c:SetFlagEffectLabel(10001000,ct+1) end end)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c101010271.con)
	e2:SetTarget(c101010271.target)
	e2:SetOperation(c101010271.operation)
	c:RegisterEffect(e2)
end
function c101010271.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsDisabled() and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x150b) and ep~=tp
end
function c101010271.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101010271.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101010271.filter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010271.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101010271.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
