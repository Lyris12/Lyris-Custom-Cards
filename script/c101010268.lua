--created & coded by Lyris
--制勝竜♒
function c101010268.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler() local ct=c:GetFlagEffectLabel(10001000) if not ct then c:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1) else c:SetFlagEffectLabel(10001000,ct+1) end end)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(function(e) return not e:GetHandler():IsDisabled() and e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x150b) end)
	e2:SetTarget(c101010268.target)
	e2:SetOperation(c101010268.operation)
	c:RegisterEffect(e2)
end
function c101010268.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev/2)
end
function c101010268.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
