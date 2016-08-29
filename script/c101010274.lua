--ジュエル・チェーン・ホイップ
function c101010274.initial_effect(c)
c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101010274.eqtg)
	e2:SetOperation(c101010274.eqop)
	c:RegisterEffect(e2)
	--chain material
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCountLimit(1,101010274)
	e7:SetCondition(c101010274.con)
	e7:SetOperation(c101010274.op)
	c:RegisterEffect(e7)
end
function c101010274.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount() and Duel.GetTurnPlayer()==tp
end
function c101010274.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010274,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	-- e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c101010274.chain_target)
	e1:SetOperation(c101010274.chain_operation)
	e1:SetValue(aux.TRUE)
	Duel.RegisterEffect(e1,tp)
end
function c101010274.filter(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c101010274.chain_target(e,te,tp)
	return Duel.GetMatchingGroup(c101010274.filter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,nil,te)
end
function c101010274.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
	e:Reset()
end
c101010274.material_race=RACE_MACHINE
function c101010274.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c101010274.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c101010274.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c101010274.atkval)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c101010274.indcon)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
	--attack again
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c101010274.caop1)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c101010274.caop2)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c101010274.eqlimit(e,c)
	return c==e:GetLabelObject()
end
c101010274.seq=0
function c101010274.caop1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if e:GetHandler():GetEquipTarget()==a and d~=nil then
		c101010274.seq=d:GetSequence()
	end
end
function c101010274.caop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	if (Duel.GetFieldCard(1-tp,LOCATION_MZONE,c101010274.seq+1)~=nil or Duel.GetFieldCard(1-tp,LOCATION_MZONE,c101010274.seq-1)~=nil) 
		and Duel.GetAttackTarget()~=nil and Duel.SelectYesNo(tp,aux.Stringid(101010274,1)) then
		local g=Group.CreateGroup()
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,c101010274.seq+1)~=nil then
			local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,c101010274.seq+1)
			if tc then g:AddCard(tc) end
		end
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,c101010274.seq-1)~=nil then
			local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,c101010274.seq-1)
			if tc then g:AddCard(tc) end
		end
		tc=g:Select(tp,1,1,nil)
		Duel.ChainAttack(tc:GetFirst())
	end
end
function c101010274.indcon(e)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function c101010274.atkval(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler():GetEquipTarget())*400
end
