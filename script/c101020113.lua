--created by LionHeartKIng
--coded by Lyris
--Rusted End Dragon
function c101020113.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,101020108,3,false,false)
	--If this card attacks a Defense Position monster, inflict doubled piercing battle damage to your opponent.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c101020113.damcon)
	e4:SetOperation(c101020113.damop)
	c:RegisterEffect(e4)
	--If this card destroys an opponent's monster by battle: Inflict 1000 damage to your opponent.
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(c101020113.damcon)
	e5:SetTarget(c101020113.damtg)
	e5:SetOperation(c101020113.damop)
	c:RegisterEffect(e5)
end
function c101020113.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsDefensePos()
end
function c101020113.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c101020113.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a~=c then d=a end
	return c:IsRelateToBattle() and d and d:IsType(TYPE_MONSTER)
end
function c101020113.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c101020113.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,v=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,v,REASON_EFFECT)
end
