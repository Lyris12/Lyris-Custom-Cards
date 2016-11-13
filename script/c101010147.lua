--created & coded by Lyris
--Cyber Space Wolf
function c101010147.initial_effect(c)
c:EnableReviveLimit()
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e6)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c101010147.spcon)
	e2:SetOperation(c101010147.spop)
	c:RegisterEffect(e2)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(c101010147.atkup)
	c:RegisterEffect(e5)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010147.aclimit)
	e1:SetCondition(c101010147.actcon)
	c:RegisterEffect(e1)
	--banished effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetTarget(c101010147.postg)
	e4:SetOperation(c101010147.posop2)
	c:RegisterEffect(e4)
end
function c101010147.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4093) and c:IsAbleToRemoveAsCost()
end
function c101010147.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c101010147.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c101010147.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010147.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010147.atkfilter(c)
	return c:IsFaceup() and c:IsCode(101010147)
end
function c101010147.atkup(e,c)
	return Duel.GetMatchingGroupCount(c101010147.atkfilter,0,LOCATION_MZONE,0,nil)*500
end
function c101010147.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101010147.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c101010147.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c101010147.posop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	if Duel.ChangePosition(g,0,0,POS_FACEUP_ATTACK,POS_FACEDOWN_ATTACK)==0 then return end
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
