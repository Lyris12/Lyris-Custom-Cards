--created & coded by Lyris
--スターナイト・サイバー・ドラゴン
function c101010218.initial_effect(c)
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ae4:SetCode(EVENT_BECOME_TARGET)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetCondition(c101010218.rmcon)
	ae4:SetOperation(c101010218.rmop)
	c:RegisterEffect(ae4)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCondition(c101010218.tgcon)
	ae1:SetValue(aux.imval1)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetCategory(CATEGORY_ATKCHANGE)
	ae2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ae2:SetCode(EVENT_SPSUMMON_SUCCESS)
	ae2:SetCondition(c101010218.atkucon)
	ae2:SetOperation(c101010218.atkuop)
	c:RegisterEffect(ae2)
	if not c101010218.global_check then
		c101010218.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010218.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010218.spatial=true
function c101010218.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
function c101010218.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local st=c:GetSummonType()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g:IsContains(c)
end
function c101010218.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CONTROLER)
	if p==tp then return end
	Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c101010218.tgcon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x7150)==0x7150
end
function c101010218.atkucon(e)
	return not c101010218.tgcon(e)
end
function c101010218.atfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsReason(REASON_MATERIAL)
end
function c101010218.atkuop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c101010218.atfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(c:GetBaseAttack()*ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_CODE)
		e0:SetValue(70095154)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0)
	end
end
