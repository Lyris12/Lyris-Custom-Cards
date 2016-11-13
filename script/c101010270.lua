--created & coded by Lyris
--Victorial Dragon Capricornus
function c101010270.initial_effect(c)
--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(function(e) return not e:GetHandler():IsDisabled() and e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x150b) end)
	e1:SetLabel(1)
	e1:SetCost(c101010270.cost)
	e1:SetTarget(c101010270.target)
	e1:SetOperation(c101010270.operation)
	c:RegisterEffect(e1)
	if not relay_check then
		relay_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010270.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010270.relay=true
c101010270.point=2
function c101010270.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function c101010270.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=ct end
	if point==ct then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-ct)
	end
end
function c101010270.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==c and bc~=nil end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,bc,1,0,0)
end
function c101010270.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if c~=nil and c:IsRelateToBattle() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
