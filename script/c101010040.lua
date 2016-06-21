--PSYStream Dragon
local id,ref=GIR()
function ref.start(c)
c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	--If this card inflicts battle damage to your opponent: You can banish 1 "PSYStream" monster from your Graveyard, and if you do, banish 1 random card from your opponent's hand, face-up, until the end of the next turn.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_BATTLE_DAMAGE)
	e0:SetCountLimit(1,id)
	e0:SetCondition(ref.rmcon)
	e0:SetCost(ref.cost)
	e0:SetTarget(ref.rmtg)
	e0:SetOperation(ref.rmop)
	c:RegisterEffect(e0)
	--If this card is banished: You can target 1 of your banished "PSYStream" cards, except "PSYStream Dragon"; add that target to your hand.
	if not ref.global_check then
		ref.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabel(id)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(e1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,201010661)
	e1:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e1:SetCondition(ref.con)
	e1:SetTarget(ref.sptg)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--This card can attack your opponent directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--If this card attacks directly, any battle damage your opponent takes becomes 900 if the amount is more than than 1300.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(ref.rdcon)
	e3:SetOperation(ref.rdop)
	c:RegisterEffect(e3)
end
function ref.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil and ev>1300
end
function ref.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,900)
end
function ref.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsSetCard(0x127)
end
function ref.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x127) and c:IsAbleToRemoveAsCost()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local rs=g:RandomSelect(1-tp,1)
	if Duel.Remove(rs,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		local fid=oc:GetFieldID()
		oc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2,fid)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(oc)
		e1:SetCondition(ref.retcon)
		e1:SetOperation(ref.retop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		Duel.Damage(1-tp,600,REASON_EFFECT)
	end
end
function ref.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function ref.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local tc=e:GetLabelObject()
	if not ref.retfilter(tc,e:GetLabel()) then
		e:Reset()
		return false
	else return true end
end
function ref.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	local ef=e:GetHandler():GetReasonEffect()
	return ef and ef:GetHandler():IsSetCard(0x127) and e:GetHandler():GetFlagEffect(id)>0
end
function ref.filter(c)
	return c:IsSetCard(0x127) and c:IsAbleToHand() and not c:IsCode(id)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
