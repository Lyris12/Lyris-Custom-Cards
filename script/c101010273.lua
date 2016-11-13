--created & coded by Lyris
--Victorial Dragon Dragotaurus
function c101010273.initial_effect(c)
c:EnableReviveLimit()
	--damage
	local ae2=Effect.CreateEffect(c)
	ae2:SetCategory(CATEGORY_DAMAGE)
	ae2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae2:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae2:SetLabel(1)
	ae2:SetCost(c101010273.cost)
	ae2:SetTarget(c101010273.damtg)
	ae2:SetOperation(c101010273.damop)
	c:RegisterEffect(ae2)
	if not relay_check then
		relay_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010273.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010273.relay=true
c101010273.point=2
function c101010273.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function c101010273.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010273.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x50b)
end
function c101010273.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if chk==0 then return bc~=nil end
	local atk1=c:GetAttack()
	local atk2=bc:GetAttack()
	local ct=Duel.GetMatchingGroupCount(c101010273.filter,tp,LOCATION_MZONE,0,nil)*500
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.abs(atk1-atk2)+ct)
end
function c101010273.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local atk1=c:GetAttack()
		local atk2=bc:GetAttack()
		local ct=Duel.GetMatchingGroupCount(c101010273.filter,tp,LOCATION_MZONE,0,nil)*500
		Duel.Damage(1-tp,math.abs(atk1-atk2)+ct,REASON_EFFECT)
	end
end

