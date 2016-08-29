--Victorial Dragon Cancerder
function c101010197.initial_effect(c)
--attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler() local ct=c:GetFlagEffectLabel(10001000) if not ct then c:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1) else c:SetFlagEffectLabel(10001000,ct+1) end end)
	c:RegisterEffect(e0)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(c101010197.defatk)
	c:RegisterEffect(e1)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010197,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101010197.potg)
	e1:SetOperation(c101010197.poop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c101010197.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c101010197.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c101010197.defatk(e)
	if e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x150b) then
		return 1
	else return 0 end
end
