--created & coded by Lyris
--ＳＳ－サファイア・コマンダー
function c101010111.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCondition(c101010111.con)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c101010111.rdcon)
	e3:SetOperation(c101010111.rdop)
	c:RegisterEffect(e3)
end
function c101010111.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetAttackedCount()>1
end
function c101010111.rdop(e,tp,eg,ep,ev,re,r,rp)
	local dam=ev-500
	if dam<0 then Duel.ChangeBattleDamage(ep,0) else Duel.ChangeBattleDamage(ep,dam) end
end
