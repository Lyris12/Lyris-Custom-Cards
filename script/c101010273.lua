--Victorial Dragon Dragotaurus
local id,ref=GIR()
function ref.start(c)
c:EnableReviveLimit()
	--damage
	local ae2=Effect.CreateEffect(c)
	ae2:SetCategory(CATEGORY_DAMAGE)
	ae2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae2:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae2:SetLabel(1)
	ae2:SetCost(ref.cost)
	ae2:SetTarget(ref.damtg)
	ae2:SetOperation(ref.damop)
	c:RegisterEffect(ae2)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.relay=true
ref.point=2
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
	Debug.ShowHint(tostring(1) .. " Point(s) removed")
end
function ref.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x50b)
end
function ref.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if chk==0 then return bc~=nil end
	local atk1=c:GetAttack()
	local atk2=bc:GetAttack()
	local ct=Duel.GetMatchingGroupCount(ref.filter,tp,LOCATION_MZONE,0,nil)*500
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.abs(atk1-atk2)+ct)
end
function ref.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local atk1=c:GetAttack()
		local atk2=bc:GetAttack()
		local ct=Duel.GetMatchingGroupCount(ref.filter,tp,LOCATION_MZONE,0,nil)*500
		Duel.Damage(1-tp,math.abs(atk1-atk2)+ct,REASON_EFFECT)
	end
end

