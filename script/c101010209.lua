--created & coded by Lyris
--If this card was Synchro Summoned using "Sea Scout - Sotileo of the Quiet Tide" as a Synchro Material Monster, this card gains 400 ATK. At the end of the Damage Step, if this card attacked: Target 1 other WATER monster you control that has attacked this turn; that target gains 300 ATK, also, it can make a second attack during this Battle Phase.
--ＳＳ－高まる潮バオルス
function c101010209.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c101010209.matcheck)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101010209.atkcon)
	e1:SetValue(400)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--2ndatk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c101010209.atcon)
	e2:SetTarget(c101010209.attg)
	e2:SetOperation(c101010209.atop)
	c:RegisterEffect(e2)
end
function c101010209.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle() and tp==Duel.GetTurnPlayer()
end
function c101010209.filter(c)
	return c:GetAttackedCount()>0 and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010209.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010209.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c101010209.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EXTRA_ATTACK)
		e0:SetValue(1)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
	end
end
function c101010209.matcheck(e,c)
	local g=c:GetMaterial()
	local sotl=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsAttribute(ATTRIBUTE_WATER) and tc:GetLevel()==4 then sotl=sotl+1 end
		tc=g:GetNext()
	end
	e:SetLabel(sotl)
end
function c101010209.atkcon(e)
	return e:GetLabelObject():GetLabel()~=0
end
