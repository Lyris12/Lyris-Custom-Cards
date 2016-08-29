--ＳＳＤ－ファイナレヴォン
function c101010206.initial_effect(c)
aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c101010206.damcon)
	e4:SetOperation(c101010206.damop)
	c:RegisterEffect(e4)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c101010206.aclimit)
	e3:SetCondition(c101010206.actcon)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e2)
	--When another monster you control is targeted for an attack: You can banish this card; banish the attacking monster.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101010206.con)
	e1:SetCost(c101010206.cost)
	e1:SetTarget(c101010206.tg)
	e1:SetOperation(c101010206.op)
	c:RegisterEffect(e1)
end
function c101010206.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101010206.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c101010206.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c101010206.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c101010206.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and c~=bt and bt:GetControler()==c:GetControler()
end
function c101010206.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c101010206.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local bc=Duel.GetAttacker()
	if chk==0 then return bc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c101010206.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	local g=Group.FromCards(tc)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		c:RegisterFlagEffect(101010206,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(101010206,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			oc=og:GetNext()
		end
		og:KeepAlive()
		--During the End Phase, if this effect was activated this turn (and was not negated): Special Summon this card, and if you do, return any monsters banished by this effect to the field, and their ATK becomes 0 until the end of your opponent's next turn.
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetTarget(c101010206.rettg)
		e1:SetOperation(c101010206.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010206.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	if chk==0 then return c:GetFlagEffect(101010206)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101010206.retfilter(c)
	return c:GetFlagEffect(101010206)~=0
end
function c101010206.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=e:GetLabelObject()
	local sg=g:Filter(c101010206.retfilter,nil)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		while tc do
			if Duel.ReturnToField(tc) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
	end
end
