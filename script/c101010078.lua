--PSYStream Miniwhale
function c101010078.initial_effect(c)
--When this card is Special Summoned: You can banish 1 "PSYStream" monster from your Deck, except "PSYStream Miniwhale".
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c101010078.rmtg)
	e5:SetOperation(c101010078.rmop)
	c:RegisterEffect(e5)
	--During either player's Main Phase, if this card was banished this turn: You can target 1 "PSYStream" monster you control; it gains this effect until the end of your turn; (effect below)
	if not c101010078.global_check then
		c101010078.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetLabel(101010078)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_REMOVED)
	e0:SetCountLimit(1,201010666)
	e0:SetCondition(c101010078.con)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(c101010078.target)
	e0:SetOperation(c101010078.operation)
	c:RegisterEffect(e0)
	--This card can attack your opponent directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--If this card attacks directly, any battle damage your opponent takes becomes 900 if the amount is more than than 900.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c101010078.rdcon)
	e3:SetOperation(c101010078.rdop)
	c:RegisterEffect(e3)
end
function c101010078.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and ev>900
end
function c101010078.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,900)
end
function c101010078.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x127) and c:IsAbleToRemove() and c:GetCode()~=101010078
end
function c101010078.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010078.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c101010078.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010078.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c101010078.con(e,tp,eg,ep,ev,re,r,rp)
	local ef=e:GetHandler():GetReasonEffect()
	return ef and ef:GetHandler():IsSetCard(0x127) and e:GetHandler():GetFlagEffect(101010078)>0 and Duel.GetTurnPlayer()==tp
end
function c101010078.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x127)
end
function c101010078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010078.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010078.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010078.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101010078.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--If it attacks directly, your opponent cannot activate monster effects until the end of the Damage Step.
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c101010078.aclimit)
		e1:SetCondition(c101010078.actcon)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		tc:RegisterEffect(e1)
	end
end
function c101010078.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and re:IsActiveType(TYPE_MONSTER)
end
function c101010078.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil
end
