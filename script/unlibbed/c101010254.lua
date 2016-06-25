--剣主 三
function c101010482.initial_effect(c)
	--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c101010482.val)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c101010482.efcon)
	e2:SetOperation(c101010482.efop)
	c:RegisterEffect(e2)
end
function c101010482.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c101010482.val(e,c)
	return Duel.GetMatchingGroupCount(c101010482.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*200
end
function c101010482.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c101010482.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(101010482,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c101010482.drtg)
	e1:SetOperation(c101010482.drop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c101010482.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetAttackTarget()
	if chk==0 then return g~=nil and g:IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101010482.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,0,0)
	end
end