--Blitzkrieg Dragon Steel
local id,ref=GIR()
function ref.start(c)
	--self-destruct
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(ref.descon)
	e3:SetOperation(ref.desop)
	c:RegisterEffect(e3)
	--desreg
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
	--During either player's Main Phase, if this card is banished or in the hand or Graveyard because it was destroyed this turn: You can add 1 "Blitzkrieg" Spell/Trap Card from your Deck to your hand. You can only use this effect of "Blitzkrieg Dragon Steel" once per turn.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x32)
	e3:SetCountLimit(1,id)
	e3:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e3:SetCondition(ref.con)
	e3:SetTarget(ref.tg)
	e3:SetOperation(ref.op)
	c:RegisterEffect(e3)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.filter(c)
	return c:IsSetCard(0x167) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
