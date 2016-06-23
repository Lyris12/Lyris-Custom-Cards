--PSYStream Sprite
local id,ref=GIR()
function ref.start(c)
	--During the turn this card was banished by a "PSYStream" card, when your opponent activates a monster effect: You can reveal the bottom card of your Deck, and if it was a "PSYStream" card, add that card to your hand, then negate the activation, and if you do, banish it. (This is a Quick Effect.)
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetLabel(id)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,id+100000000)
	e1:SetCondition(ref.con)
	e1:SetOperation(ref.operation)
	c:RegisterEffect(e1)
	--This card can attack your opponent directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--If this card attacks directly, any battle damage your opponent takes becomes 800 if the amount is more than than 800.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(ref.rdcon)
	e3:SetOperation(ref.rdop)
	c:RegisterEffect(e3)
end
function ref.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and ev>800
end
function ref.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,800)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) or not Duel.IsChainNegatable(ev) then return false end
	local ef=e:GetHandler():GetReasonEffect()
	return ef and ef:GetHandler():IsSetCard(0x127) and e:GetHandler():GetFlagEffect(id)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dr=Duel.GetFieldCard(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(1-tp,dr)
	Duel.ConfirmCards(tp,dr)
	if dr:IsSetCard(0x127) and Duel.SendtoHand(dr,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,dr)
		Duel.ShuffleHand(tp)
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
