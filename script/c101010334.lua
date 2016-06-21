--White Wisteria Wyvern
local id,ref=GIR()
function ref.start(c)
	aux.EnablePendulumAttribute(c)
	--You cannot Pendulum Summon monsters, except Normal Monsters. This effect cannot be negated.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetCondition(aux.nfbdncon)
	e0:SetTarget(ref.splimit)
	c:RegisterEffect(e0)
	--If a Normal Monster you control attacks a face-down monster, you cannot activate Spell Cards during the Damage Step of that battle, also, your monster's ATK becomes double its original ATK during the Damage Step only.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(ref.atkcon)
	e1:SetOperation(ref.atkop)
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
	e2:SetTarget(ref.tg)
	e2:SetOperation(ref.op)
	c:RegisterEffect(e2)
end
function ref.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function ref.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a then return false end
	if a:IsControler(1-tp) then return false end
	return d and a:IsRelateToBattle() and d:IsRelateToBattle()
		and a:IsType(TYPE_NORMAL) and d:IsFacedown()
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(ref.atkupcon)
	e1:SetValue(ref.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e2:SetCondition(ref.atkupcon)
	e2:SetValue(eg:GetFirst():GetBaseAttack()*2)
	eg:GetFirst():RegisterEffect(e2)
end
function ref.atkupcon(e)
	local phase=Duel.GetCurrentPhase()
	return phase==PHASE_DAMAGE or phase==PHASE_DAMAGE_CAL
end
function ref.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsCanTurnSet()
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,ref.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
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
