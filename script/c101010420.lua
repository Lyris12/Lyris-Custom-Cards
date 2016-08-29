--, also, other monsters you control cannot attack this turn
--ＳＳＤ－津波
function c101010420.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),2)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c101010420.aclimit)
	e1:SetCondition(c101010420.actcon)
	c:RegisterEffect(e1)
	--When this card inflicts Battle Damage, if at least 3 other monsters you control have attacked this turn: The player who took the Battle Damage destroys all other monsters they control.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101010420.con)
	e3:SetTarget(c101010420.tg)
	e3:SetOperation(c101010420.op)
	c:RegisterEffect(e3)
	if not c101010420.global_check then
		c101010420.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c101010420.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c101010420.check2)
		Duel.RegisterEffect(ge2,0)
		ge2:SetLabelObject(ge1)
		e3:SetLabelObject(ge1)
	end
end
function c101010420.aclimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsImmuneToEffect(e)
end
function c101010420.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
--[[function c101010420.fatg(e,c)
	return c~=e:GetHandler() and c:IsAttackable()
end
function c101010420.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:IsExists(Card.IsAttackable,1,nil)
end]]
function c101010420.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local ct=e:GetLabel()
	if tc~=c then
		if ct~=0 then
			e:SetLabel(ct+1)
			else
			e:SetLabel(1)
		end
	end
end
function c101010420.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=e:GetLabelObject():GetLabel()
	if ct~=0 then
		e:SetLabel(ct-1)
	end
end
function c101010420.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetLabelObject():GetLabel()>2
end
function c101010420.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end--Duel.IsExistingMatchingCard(Card.IsDestructable,ep,LOCATION_MZONE,0,e:GetHandler())
	local g=Duel.GetMatchingGroup(Card.IsDestructable,ep,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101010420.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,ep,LOCATION_MZONE,0,c)
	Duel.Destroy(g,REASON_EFFECT)
end
