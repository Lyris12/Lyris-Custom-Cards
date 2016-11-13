--created & coded by Lyris
--White Wisteria Wyvern
function c101010334.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--You cannot Pendulum Summon monsters, except Normal Monsters. This effect cannot be negated.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetCondition(aux.nfbdncon)
	e0:SetTarget(c101010334.splimit)
	c:RegisterEffect(e0)
	--If a Normal Monster you control attacks a face-down monster, your monster gains 1000 ATK during the Damage Step only.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(c101010334.atktg)
	c:RegisterEffect(e1)
	--During your opponent's turn: You can target 1 Effect Monster your opponent controls; change that target to face-down Attack Position. Monsters changed to face-down Attack Position by this effect cannot change their battle positions this turn. You can only use the effect of "White Wisteria Wyvern" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101010334)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetTurnPlayer()~=tp end)
	e2:SetTarget(c101010334.tg)
	e2:SetOperation(c101010334.op)
	c:RegisterEffect(e2)
end
function c101010334.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010334.atktg(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	local bc=c:GetBattleTarget()
	if c:IsType(TYPE_NORMAL) and c==Duel.GetAttacker() and bc and bc:IsFacedown() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetCondition(c101010334.atkcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
	end
end
function c101010334.atkcon(e)
	local phase=Duel.GetCurrentPhase()
	return phase==PHASE_DAMAGE or phase==PHASE_DAMAGE_CAL
end
function c101010334.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsCanTurnSet()
end
function c101010334.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101010334.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010334.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c101010334.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101010334.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
