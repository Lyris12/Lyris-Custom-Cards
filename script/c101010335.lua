--White Wisteria Wisp
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
	--"White Wisteria" Spell/Trap Cards cannot be targeted by your opponent's Spell/Trap effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(ref.pcttg)
	e1:SetValue(ref.pctval)
	c:RegisterEffect(e1)
	--Once per turn: You can target 1 Normal Monster you control; change that target to face-down Attack Position, and if you do, your opponent cannot activate Trap Cards during this turn's Battle Phase.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.tg)
	e2:SetOperation(ref.op)
	c:RegisterEffect(e2)
end
function ref.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function ref.pcttg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb0)
end
function ref.pctval(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsCanTurnSet()
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetCondition(ref.con)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(ref.aclimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function ref.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function ref.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
