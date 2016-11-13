--created & coded by Lyris
--White Wisteria Wing
function c101010333.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--You cannot Pendulum Summon monsters, except Normal Monsters. This effect cannot be negated.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetCondition(aux.nfbdncon)
	e0:SetTarget(c101010333.splimit)
	c:RegisterEffect(e0)
	--Face-down Attack Position monsters you control cannot be destroyed by card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEDOWN_ATTACK))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--When a Normal Monster you control is targeted by an attack or effect: You can return that monster to your hand and Special Summon this card from your Pendulum Zone in face-down Attack Position.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c101010333.con)
	e2:SetTarget(c101010333.tg)
	e2:SetOperation(c101010333.op)
	c:RegisterEffect(e2)
end
function c101010333.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010333.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return r~=REASON_REPLACE and tc:IsControler(e:GetHandler():GetControler()) and tc:IsFaceup() and tc:IsType(TYPE_NORMAL)
end
function c101010333.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if chk==0 then return tc:IsAbleToHand() and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_ATTACK) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101010333.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<0 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_ATTACK) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_ATTACK)
		Duel.ConfirmCards(1-tp,c)
	end
end
