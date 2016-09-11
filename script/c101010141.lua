--F・HEROプロヒビットガイ
function c101010141.initial_effect(c)
--damage half
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_DESTROY)
	e0:SetOperation(c101010141.regop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(c101010141.rdcon)
	e4:SetCost(c101010141.rdcost)
	e4:SetOperation(c101010141.rdop)
	c:RegisterEffect(e4)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010141,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101010141.actcon)
	e2:SetCost(c101010141.actcost)
	e2:SetTarget(c101010141.acttg)
	e2:SetOperation(c101010141.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101010141,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
end
function c101010141.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,101010141)~=0 then return end
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		if rp~=c:GetControler() then
			e1:SetTargetRange(1,0)
		else
			e1:SetTargetRange(0,1)
		end
		e1:SetValue(c101010141.val)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,101010141,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101010141.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	return bc~=nil and bc:IsFaceup() and bc:IsSetCard(0x9008)
end
function c101010141.rdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101010141.rdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c101010141.damop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010141.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c101010141.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010091)~=0
end
function c101010141.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9008)
end
function c101010141.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckReleaseGroup(tp,c101010141.cfilter,1,nil) and Duel.SelectYesNo(tp,500) then
		local g=Duel.SelectReleaseGroup(tp,c101010141.cfilter,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		Duel.Release(g,REASON_COST)
		else return true
	end
end
function c101010141.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010141.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		local tc=e:GetLabelObject()
		if tc and tc.after then
			c:CopyEffect(tc:GetCode(),RESET_EVENT+0x1ff0000)
			tc.after(e,tp)
		end
	end
end
function c101010141.val(e,re,dam)
	return dam/2
end
